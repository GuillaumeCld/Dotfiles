# Define variables for input and output file MY_SITE_PATHs
MY_SITE_PATH = ${HOME}/Documents/MySite
# Get all org files
ORG_NOTE_FILES := $(wildcard $(MY_SITE_PATH)/content-org/Notes/*.org)
ORG_POST_FILES := $(wildcard $(MY_SITE_PATH)/content-org/Posts/*.org)
# Substitute all ".org" file name strings to ".md" file name strings
MD_NOTE_FILES := $(patsubst $(MY_SITE_PATH)/content-org/Notes/%.org, $(MY_SITE_PATH)/content/notes/%.md, $(ORG_NOTE_FILES))
MD_POST_FILES := $(patsubst $(MY_SITE_PATH)/content-org/Posts/%.org, $(MY_SITE_PATH)/content/posts/%.md, $(ORG_POST_FILES))

# Define phony targets
.PHONY: all notes posts clean

# Define the default target, which depends on the 'notes' and 'posts' targets
all: notes posts

# Define the 'notes' target, which depends on all the md files in the notes folder
notes: $(MD_NOTE_FILES)


# Define the 'posts' target, which depends on all the md files in the posts folder
posts: $(MD_POST_FILES)

# Define the rule for converting an org file to an md file for a note
$(MY_SITE_PATH)/content/notes/%.md: $(MY_SITE_PATH)/content-org/Notes/%.org
	emacsclient --eval "(find-file \"$^\")" --eval "(org-hugo-export-wim-to-md)"
	@echo "Exported $@ from $<"

# Define the rule for converting an org file to an md file for a post
$(MY_SITE_PATH)/content/posts/%.md: $(MY_SITE_PATH)/content-org/Posts/%.org
	emacsclient --eval "(find-file \"$^\")" --eval "(org-hugo-export-wim-to-md)"
	@echo "Exported $@ from $<"

# Define the 'clean' target, which removes all the generated md files
clean:
	rm -f $(MD_NOTE_FILES) $(MD_POST_FILES)
