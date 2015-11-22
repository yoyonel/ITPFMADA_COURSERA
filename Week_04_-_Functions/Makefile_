# url: http://stackoverflow.com/questions/3774568/makefile-issue-smart-way-to-scan-directory-tree-for-c-files
ECHO = echo
CHUCK_GEN := chuck
CHUCK_SRC := ChucK-Src

# url: http://superuser.com/questions/559824/how-to-get-only-names-from-find-command-without-path
SRC_CHUCK := $(shell find $(CHUCK_SRC) -name '*.ck' -exec basename \{} .ck \;  )
# url: http://stackoverflow.com/questions/4320416/how-to-use-a-variable-list-as-a-target-in-a-makefile
TARGET_CHUCK := $(SRC_CHUCK:.ck=)

$(phony all): $(TARGET_CHUCK)	# All is the first target, so it's the default.

$(TARGET_CHUCK):
	$(CHUCK_GEN) $(CHUCK_SRC)/$@

help:
	@$(ECHO) "Targets:"
	#url: http://stackoverflow.com/questions/6498727/makefile-show-and-execute
	@$(foreach l, $(TARGET_CHUCK), $(ECHO) $l)
