FROM ubuntu:18.04
LABEL maintainer="Hong-She Liang <starofrainnight@gmail.com>"
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y \
    wget \
    subversion \
    apache2-utils \
    python \
    nano \
    patch \
    # TracMasterTickets degraph support
    python-pydot python-pydot-ng graphviz \
    && apt-get clean

RUN wget https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py \
    && rm get-pip.py

RUN pip install -U setuptools
RUN easy_install -U pip
RUN pip install -U wheel
RUN pip install virtualenv

RUN pip install pillow
RUN pip install reportlab
RUN pip install html5lib
RUN pip install pisa

# For tracwikiprintplugin, previous python-pil and python-reportlab also needs for this.
RUN pip install xhtml2pdf
RUN pip install pypdf
# Latest version can't work with 0.12.x
RUN pip install pygments==1.6
RUN pip install pytz
RUN pip install docutils
RUN pip install babel

RUN pip install trac==0.12.7
RUN easy_install -Z -U https://trac-hacks.org/svn/tracwikiprintplugin/0.11
# Trac<1.0, avoid issue: No handler matched request to /login
RUN pip install TracAccountManager==0.4.4
RUN pip install TracPrivateTickets==2.3.0
RUN pip install TracMasterTickets==3.0.1
RUN easy_install -Z -U https://trac-hacks.org/svn/xmlrpcplugin/trunk
RUN easy_install -Z -U https://trac-hacks.org/svn/datefieldplugin/0.12/
RUN easy_install -Z -U https://trac-hacks.org/svn/discussionplugin/0.11/
RUN easy_install https://github.com/itota/trac-subtickets-plugin/zipball/master
# Latest version can't work with 0.12.x
RUN wget --no-check-certificate -O fullblogplugin.zip https://trac-hacks.org/browser/fullblogplugin/0.11\?rev=14774\&format=zip \
    && easy_install fullblogplugin.zip && rm fullblogplugin.zip
RUN easy_install -Z -U https://trac-hacks.org/svn/tracjsganttplugin/0.11/
RUN easy_install -Z -U https://trac-hacks.org/svn/virtualticketpermissionsplugin/trunk/
RUN easy_install -Z -U https://trac-hacks.org/svn/tracwysiwygplugin/0.12/
RUN easy_install -Z -U https://trac-hacks.org/svn/timingandestimationplugin/branches/trac0.12-Permissions/
RUN easy_install -Z -U https://trac-hacks.org/svn/ccselectorplugin/trunk/
RUN easy_install -Z -U https://trac-hacks.org/svn/svnauthzadminplugin/0.12/

RUN mkdir /opt/docker-trac
ADD files/entrypoint.sh /opt/docker-trac/entrypoint.sh
RUN chmod a+x /opt/docker-trac/*.sh

# Fix libraries
ADD files/patches /tmp/patches
RUN cd /tmp/patches && chmod +x *.sh && ./apply-patch.sh && rm -rf /tmp/patches

VOLUME /srv/trac
EXPOSE 80

ENTRYPOINT ["/opt/docker-trac/entrypoint.sh"]
