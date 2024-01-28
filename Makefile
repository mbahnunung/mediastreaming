-include config.mk

ADMIN_PASSWORD	?=	secure
HARBOR_PASSWORD	?=	secure
SOURCE_PASSWORD	?=	secure
RELAY_PASSWORD  ?=	secure
MYSQL_PASSWORD  ?=	secure
HOSTNAME	?=	$(shell hostname -f)
ADMIN_IFRAME_URL ?=	http://$(shell ifconfig eth0 | grep inet\  | cut -d: -f2 | cut -d\  -f1):12348/admin.php?auth=$(ADMIN_PASSWORD)

ENV ?=		HARBOR_PASSWORD=$(HARBOR_PASSWORD) \
			LIVE_PASSWORD=$(HARBOR_PASSWORD) \
			ICECAST_SOURCE_PASSWORD=$(SOURCE_PASSWORD) \
			ICECAST_ADMIN_PASSWORD=$(ADMIN_PASSWORD) \
			ICECAST_PASSWORD=$(ADMIN_PASSWORD) \
			ICECAST_RELAY_PASSWORD=$(RELAY_PASSWORD) \
			MYSQL_ROOT_PASSWORD=$(MYSQL_PASSWORD) \
			PIWIK_MYSQL_PASSWORD=$(MYSQL_PASSWORD) \
			PIWIK_PASSWORD=$(PIWIK_PASSWORD) \
			HOSTNAME=$(HOSTNAME) \
			SITE_URL=https://$(HOSTNAME):12347 \
			ADMIN_IFRAME_URL=$(ADMIN_IFRAME_URL)

.PHONY: dev re_main re_broadcast re_icecast main broadcast icecast admin ftpd


.PHONY: up
up:
	$(ENV) docker-compose up -d --no-recreate

dev:	chmod broadcast
	$(ENV) docker-compose up --no-deps main


re_main: broadcast
	-$(ENV) docker-compose kill main
	-$(ENV) docker-compose rm --force main
	-$(ENV) docker-compose up -d --no-deps main
	$(MAKE) admin
	-$(ENV) docker-compose logs main


re_broadcast: icecast
	-$(ENV) docker-compose kill broadcast
	-$(ENV) docker-compose rm --force broadcast
	-$(ENV) docker-compose up -d --no-deps broadcast
	-$(ENV) docker-compose logs broadcast


re_icecast:
	-$(ENV) docker-compose kill icecast
	-$(ENV) docker-compose rm --force icecast
	-$(ENV) docker-compose up -d --no-deps icecast
	-$(ENV) docker-compose logs icecast


main:	broadcast
	$(ENV) docker-compose up -d --no-deps --no-recreate $@

broadcast: icecast
	$(ENV) docker-compose up -d --no-deps --no-recreate $@

icecast:
	$(ENV) docker-compose up -d --no-deps --no-recreate $@


admin:
	-$(ENV) docker-compose kill $@
	-$(ENV) docker-compose rm --force $@
	$(ENV) docker-compose up -d --no-deps $@
	#$(ENV) docker-compose logs $@


kill:
	docker-compose kill


clean:	kill
	docker-compose --force rm


chmod:
	chmod -R 777 data playlists

ftpd:
	-$(ENV) docker-compose kill $@
	-$(ENV) docker-compose rm --force $@
	$(ENV) docker-compose up -d --no-deps $@
	$(ENV) docker-compose logs $@
