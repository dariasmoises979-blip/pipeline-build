FROM alpine:3.18

RUN adduser -D appuser
USER appuser
RUN mkdir /test && \
    chown -R appuser:appuser /test && \
    chmod -R 777 /test
WORKDIR /app
COPY . .

CMD ["sh"]
