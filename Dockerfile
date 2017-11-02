FROM            base
MAINTAINER      kaythechemist@gmail.com

# 실수 방지 : base를 오랫동안 업데이트하지 않았을 때 대비.
ENV             LANG C.UTF-8

# 파일 복사 및 설치
COPY            . /srv/app
RUN             /root/.pyenv/versions/app/bin/pip install -r /srv/app/requirements.txt

WORKDIR         /srv/app
RUN             pyenv local app

# Nginx
RUN             cp /srv/app/.config/nginx/nginx.conf /etc/nginx/nginx.conf
RUN             cp /srv/app/.config/nginx/app.conf /etc/nginx/sites-available/
RUN             rm -rf /etc/nginx/sites-enabled/*
RUN             ln -sf /etc/nginx/sites-available/app.conf /etc/nginx/sites-enabled/app.conf

# uWSGI
RUN             mkdir -p /var/log/uwsgi/app

# supervisor
RUN             cp /srv/app/.config/supervisor/* /etc/supervisor/conf.d/
CMD             supervisord -n
