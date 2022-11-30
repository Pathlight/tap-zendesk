CONF_DIR?=./configs/default
TARGET_DIR?=../target-postgres

.PHONY: run
run:
	tap-zendesk -c "$(CONF_DIR)"/config.json --catalog "$(CONF_DIR)"/catalog.json -p "$(CONF_DIR)"/catalog.json -s "$(CONF_DIR)"/state.json | \
	"$(TARGET_DIR)"/venv/bin/target-postgres -c "$(CONF_DIR)"/target_config.json

.PHONY: clean_catalog
clean-catalog:
	rm "$(CONF_DIR)"/catalog.json

.PHONY: discover
discover: "$(CONF_DIR)"/catalog.json

"$(CONF_DIR)"/catalog.json: $(CONF_DIR)
	tap-zendesk -c "$(CONF_DIR)"/config.json -d > "$(CONF_DIR)"/catalog.json

.PHONY: tap
tap: $(CONF_DIR)
	tap-zendesk -c "$(CONF_DIR)"/config.json --catalog "$(CONF_DIR)"/catalog.json -p "$(CONF_DIR)"/catalog.json -s "$(CONF_DIR)"/state.json

.PHONY: target
target: $(CONF_DIR)
	"$(TARGET_DIR)"/venv/bin/target-postgres -c "$(CONF_DIR)"/target_config.json

.PHONY: test
test:
	pytest --color=no --verbose