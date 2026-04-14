ARG IMAGE=python
#ARG IMAGE_TAG="3.14.4-alpine3.23"
ARG IMAGE_TAG="3.14.4-slim-trixie"
FROM ${IMAGE}:${IMAGE_TAG}
ARG PACKAGES="python3-dev gcc make musl-dev"
ENV PORT=8000
ENV APP_DIR=/web/www/app
ENV APP=app:app
WORKDIR /tmp
COPY ./pyproject.toml ./
#RUN apk update && apk add --no-cache $PACKAGES
RUN apt update && apt install -y $PACKAGES && apt clean
RUN pip install --upgrade pip && pip install . --break-system-packages
RUN mkdir -p $APP_DIR
COPY app.py $APP_DIR/
#CMD ["pip", "list"]
ENTRYPOINT cd $APP_DIR && uvicorn $APP --app-dir $APP_DIR --host 0.0.0.0 --port $PORT --reload
EXPOSE $PORT/tcp
