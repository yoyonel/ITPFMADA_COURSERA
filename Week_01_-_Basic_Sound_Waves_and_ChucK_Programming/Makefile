# url: http://stackoverflow.com/questions/3774568/makefile-issue-smart-way-to-scan-directory-tree-for-c-files
ECHO = echo
CHUCK_GEN := chuck

SOUNDS_CHUCK := Assignment_1_Heart_Song Assignment_1_MeloDramaTick_Heart_Song

$(phony all): $(SOUNDS_CHUCK)	# All is the first target, so it's the default.

Assignment_1_Heart_Song: src/Assignment_1_Heart_Song.ck
	$(CHUCK_GEN) src/Assignment_1_Heart_Song.ck

Assignment_1_MeloDramaTick_Heart_Song: src/Assignment_1_MeloDramaTick_Heart_Song.ck
	$(CHUCK_GEN) src/Assignment_1_MeloDramaTick_Heart_Song.ck

help:
	@$(ECHO) "Targets:"
	@$(ECHO) "Assignment_1_Heart_Song"
	@$(ECHO) "Assignment_1_MeloDramaTick_Heart_Song"
