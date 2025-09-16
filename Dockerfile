FROM debian:trixie-slim
ARG DEBIAN_FRONTEND=noninteractive
ENV PORT=8000
ENV APP_DIR=/opt
ENV APP=app:app
WORKDIR /tmp
RUN apt update && apt install -y python3-full python3-pip
COPY ./pyproject.toml ./
RUN pip install . --break-system-packages
RUN apt clean && rm -Rf /var/lib/apt/lists/*
RUN mkdir -p $APP_DIR
COPY *.py $APP_DIR/
#ENTRYPOINT cd $APP_DIR && hypercorn -b 0.0.0.0:$PORT -w 1 --access-logfile '-' $APP
ENTRYPOINT cd $APP_DIR && uvicorn $APP --app-dir $APP_DIR --host 0.0.0.0 --port $PORT --reload
EXPOSE $PORT/tcp
