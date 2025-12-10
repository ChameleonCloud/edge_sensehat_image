FROM python:3.13-slim-bookworm AS rpi-sense-builder

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y \
    git \
    build-essential

RUN pip install setuptools build
RUN git clone https://github.com/RPi-Distro/RTIMULib \
    && cd RTIMULib/Linux/python/ \
    && python3 -m build --wheel --no-isolation --outdir /app/wheels \
    && pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels sense-hat

FROM python:3.13-slim-bookworm AS waveshare-sense-builder

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y \
    git \
    gcc \
    make \
    unzip \
    swig

RUN pip install \
    setuptools \
    build

ADD http://abyz.me.uk/lg/lg.zip .
RUN unzip lg.zip \
    && cd lg \
    && make \
    && make install


RUN pip wheel \
    --no-cache-dir \
    --no-deps \
    --wheel-dir /app/wheels \
    lgpio \
    rpi-lgpio \
    sysv_ipc \
    adafruit-blinka \
    adafruit-circuitpython-ads1x15 \
    adafruit-circuitpython-icm20x \
    adafruit-circuitpython-lps2x \
    adafruit-circuitpython-shtc3 \
    adafruit-circuitpython-tcs34725

FROM python:3.13-slim-bookworm AS output

WORKDIR /app

# install runtime utils and deps 
RUN apt-get update && apt-get install -y \
    i2c-tools \
    gpiod \
    && rm -rf /var/lib/apt/lists/*

COPY --from=rpi-sense-builder /app/wheels /wheels
COPY --from=waveshare-sense-builder /app/wheels /wheels
COPY --from=waveshare-sense-builder /usr/local/lib/liblgpio.so.1 /usr/local/lib/
RUN ldconfig

# install dependencies
RUN pip install \
    --no-cache \
    /wheels/* \
    && rm -rf /wheels/

COPY examples /app/examples

ENTRYPOINT [ "/bin/bash" ]
CMD ["sleep", "infinity"]
