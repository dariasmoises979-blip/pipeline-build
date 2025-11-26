FROM alpine:3.18

RUN adduser -D appuser
USER appuser
RUN chown -R appuser:appuser /app && \
    chmod -R 777 /app
WORKDIR /app
COPY . .

CMD ["sh"]
