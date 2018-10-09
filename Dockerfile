FROM ubuntu:16.04
MAINTAINER Odoo <test@gmail.com>

# Generate locale C.UTF-8 for postgres and general locale data
ENV LANG C.UTF-8
# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf

RUN set -x; \
    apt-get update 
RUN apt-get install -y --no-install-recommends \
    vim \
    git \
    python3-pip \
    build-essential \
    python3-dev \
    libxslt-dev \
    libzip-dev \
    libldap2-dev \
    libsasl2-dev \
    node-less \
    python3-setuptools \
    postgresql-client \
    curl
RUN useradd --system  --home /opt --shell /bin/bash  --uid 1000 odoo && \
    mkdir -p /opt/odoo


# WKHTMLTOPDF dependencies end
            #### End apt-get extra packages
RUN curl -o wkhtmltox.tar.xz -SL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz \
    && echo '3f923f425d345940089e44c1466f6408b9619562 wkhtmltox.tar.xz' | sha1sum -c - \
    && tar xvf wkhtmltox.tar.xz \
    && cp wkhtmltox/lib/* /usr/local/lib/ \
    && cp wkhtmltox/bin/* /usr/local/bin/ \
    && cp -r wkhtmltox/share/man/man1 /usr/local/share/man/

RUN git clone https://www.github.com/odoo/odoo --depth 1 --branch 11.0 /opt/odoo/odoo
RUN pip3 install --upgrade pip
RUN pip3 install -r /opt/odoo/odoo/requirements.txt
RUN mkdir /opt/odoo/extra-addons
RUN mkdir /etc/odoo
COPY ./odoo.conf /opt/odoo/etc/odoo.conf
#RUN chown -R odoo:odoo  /opt/
USER odoo
WORKDIR /opt/odoo/odoo
#RUN /bin/bash -c "./odoo-bin -c /opt/odoo/etc/odoo.conf"
#ENTRYPOINT ["./odoo-bin -c /opt/odoo/etc/odoo.conf"]
SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["./odoo-bin"]
# -c /opt/odoo/etc/odoo.conf
