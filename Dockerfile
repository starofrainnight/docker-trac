FROM ubuntu:20.04
LABEL maintainer="Hong-She Liang <starofrainnight@gmail.com>"
ENV LANG C.UTF-8
# Avoiding user interaction with tzdata
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    wget \
    subversion \
    apache2-utils \
    python \
    nano \
    patch \
    # TracMasterTickets degraph support
    graphviz \
    # TracWikiPrintPlugin dependences
    wkhtmltopdf \
    && apt-get clean
RUN apt-get install -y pip python-setuptools && apt-get clean
# RUN wget https://bootstrap.pypa.io/get-pip.py \
#     && python get-pip.py \
#     && rm get-pip.py
RUN python -m easy_install pip==20.3.4
# RUN pip install -U setuptools
# RUN python3 -m pip install -U pip
RUN python -m pip install -U wheel
RUN python -m pip install virtualenv

# TracMasterTickets degraph support
RUN python -m pip install pydot
RUN python -m pip install pydot-ng

RUN python -m pip install pillow
RUN python -m pip install reportlab
RUN python -m pip install html5lib
RUN python -m pip install pisa

# For tracwikiprintplugin, previous python-pil and python-reportlab also needs for this.
RUN python -m pip install xhtml2pdf==0.2.5
RUN python -m pip install pypdf
# Latest version can't work with 0.12.x
# RUN pip install pygments==1.6
RUN python -m pip install pygments
RUN python -m pip install pytz
RUN python -m pip install docutils
RUN python -m pip install babel==2.8.1

RUN python -m pip install trac==1.0.20
RUN python -m easy_install -Z -U https://trac-hacks.org/svn/tracwikiprintplugin/trunk
# Trac<1.0, avoid issue: No handler matched request to /login
RUN python -m pip install TracAccountManager==0.5.0
RUN python -m pip install TracPrivateTickets==2.3.0
RUN python -m pip install TracMasterTickets==4.0.4
RUN python -m easy_install -Z -U https://trac-hacks.org/svn/xmlrpcplugin/trunk
# deprecated, use custom fields instead
# RUN easy_install -Z -U https://trac-hacks.org/svn/datefieldplugin/0.12/
# unmaintained
# RUN easy_install -Z -U https://trac-hacks.org/svn/discussionplugin/0.11/
# RUN python -m easy_install https://github.com/itota/trac-subtickets-plugin/zipball/master
RUN python -m easy_install https://github.com/itota/trac-subtickets-plugin/archive/refs/heads/master.zip
# Latest version can't work with 0.12.x
# RUN wget --no-check-certificate -O fullblogplugin.zip https://trac-hacks.org/browser/fullblogplugin/0.11\?rev=14774\&format=zip \
#    && python -m easy_install fullblogplugin.zip && rm fullblogplugin.zip

# Needs migrate-tracblog.py when upgrade from 0.12.x
#RUN python -m easy_install -Z -U https://trac-hacks.org/browser/fullblogplugin/1.4
RUN python -m easy_install -Z -U https://trac-hacks.org/svn/fullblogplugin/1.4/

# For Trac 1.0 and earlier
RUN python -m easy_install -Z -U https://trac-hacks.org/svn/tracjsganttplugin/0.11/

# Unmaintained
# RUN easy_install -Z -U https://trac-hacks.org/svn/virtualticketpermissionsplugin/trunk/

# Try to see if it's works under 1.x
RUN python -m easy_install -Z -U https://trac-hacks.org/svn/tracwysiwygplugin/0.12/

RUN python -m easy_install -Z -U https://trac-hacks.org/svn/timingandestimationplugin/branches/trac1.0-Permissions/

RUN python -m easy_install -Z -U https://trac-hacks.org/svn/ccselectorplugin/trunk/
RUN python -m easy_install -Z -U https://trac-hacks.org/svn/svnauthzadminplugin/1.0/

RUN mkdir /opt/docker-trac
ADD files/entrypoint.sh /opt/docker-trac/entrypoint.sh
RUN chmod a+x /opt/docker-trac/*.sh

VOLUME /srv/trac
EXPOSE 80

ENTRYPOINT ["/opt/docker-trac/entrypoint.sh"]
