ARG RUNTIME="python:3.14"
FROM ${RUNTIME}-alpine
ARG PACKAGES="python3-dev gcc make musl-dev"
ENV PORT=8000
ENV APP_DIR=/opt/www/app
ENV APP=app:app
WORKDIR /tmp
COPY ./pyproject.toml ./
RUN apk update && apk add --no-cache $PACKAGES
RUN pip install --upgrade pip && pip install . --break-system-packages
RUN mkdir -p $APP_DIR
COPY *.py $APP_DIR/
ENTRYPOINT cd $APP_DIR && uvicorn $APP --app-dir $APP_DIR --host 0.0.0.0 --port $PORT --reload
EXPOSE $PORT/tcp
