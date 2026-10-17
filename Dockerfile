FROM alpine:3.19

# تنظیم نسخه دقیق بر روی v3.9.0
ARG XUI_VERSION=v3.9.0
ARG ARCH=amd64

RUN apk add --no-cache \
    curl \
    bash \
    ca-certificates \
    tzdata \
    sqlite \
    && ln -sf /usr/share/zoneinfo/Asia/Tehran /etc/localtime

# دانلود و استخراج نسخه v3.8.5 پنل
RUN curl -fSL "https://github.com/mhsanaei/3x-ui/releases/download/${XUI_VERSION}/x-ui-linux-${ARCH}.tar.gz" -o /tmp/x-ui.tar.gz \
    && tar -xzf /tmp/x-ui.tar.gz -C /usr/local/ \
    && rm /tmp/x-ui.tar.gz

# تنظیم مجوز دسترسی اجرا به فایل‌های اصلی و bin
RUN chmod +x /usr/local/x-ui/x-ui \
    && chmod +x /usr/local/x-ui/x-ui.sh \
    && chmod -R +x /usr/local/x-ui/bin/

# ایجاد Symlink جهت اطمینان از شناسایی فایل هسته Xray در هر شرایطی
RUN if [ -f /usr/local/x-ui/bin/xray-linux-amd64 ]; then \
         ln -sf /usr/local/x-ui/bin/xray-linux-amd64 /usr/local/x-ui/bin/xray; \
    elif [ -f /usr/local/x-ui/bin/xray ]; then \
         ln -sf /usr/local/x-ui/bin/xray /usr/local/x-ui/bin/xray-linux-amd64; \
    fi

# تنظیم دقیق پوشه کاری (جلوگیری از خطای no such file or directory)
WORKDIR /usr/local/x-ui

EXPOSE 2096

CMD ["./x-ui"]
