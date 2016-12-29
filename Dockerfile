FROM ubuntu:14.04
MAINTAINER Hong-She Liang <starofrainnight@gmail.com>

ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y \
    wget \
    subversion \
    python \
    python-pil \
    python-reportlab \
    && apt-get clean

RUN wget https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py \
    && rm get-pip.py

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
RUN pip install TracAccountManager
RUN pip install TracPrivateTickets
RUN pip install TracMasterTickets
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

ADD files/entrypoint.sh /usr/local/bin/

RUN chmod a+x /usr/local/bin/*.sh

VOLUME /srv/trac
EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
