# url: http://stackoverflow.com/questions/3774568/makefile-issue-smart-way-to-scan-directory-tree-for-c-files
ECHO = echo
CHUCK_GEN := chuck
CHUCK_SRC := ChucK-Src

# url: http://superuser.com/questions/559824/how-to-get-only-names-from-find-command-without-path
#SRC_CHUCK := $(shell find $(CHUCK_SRC) -name '*.ck' -exec basename \{} .ck \;  )
#SRC_CHUCK := $(shell find $(CHUCK_SRC) -name '*.ck' -exec basename \\{} \;  )
# url: http://stackoverflow.com/questions/4320416/how-to-use-a-variable-list-as-a-target-in-a-makefile
#TARGET_CHUCK := $(SRC_CHUCK:.ck=)
TARGET_CHUCK := $(shell find $(CHUCK_SRC) -name '*.ck' -exec basename \{} .ck \;  )

#$(info TARGET_CHUCK=$(TARGET_CHUCK))
#$(info $(foreach l, $(TARGET_CHUCK), $l))
#$(info SRC_CHUCK=$(SRC_CHUCK))

$(phony all): $(TARGET_CHUCK)	# All is the first target, so it's the default.

$(TARGET_CHUCK):
	$(CHUCK_GEN) $(CHUCK_SRC)/$@

help:
	@$(ECHO) "List of Targets:"
#url: http://stackoverflow.com/questions/6498727/makefile-show-and-execute
#	@$(ECHO) $(foreach l, $(TARGET_CHUCK), $l${NEWLINE})
#url: http://stackoverflow.com/questions/29651388/insert-a-new-line-in-a-makefile-foreach-loop
	@(for target in $(TARGET_CHUCK); do echo $$target ; done)
