KB-TOOLS

## Name
    configs - user defined configs
    create-article.sh - does admin tasks for creation of an article
    reset-to-upstream.sh - resets environment to upstream
    setup-kb-local-repo.sh - initial setup script to create your local repo

## SYNOPSIS

    create-article.sh [-q|-i|-h]["Quotes encapsuled article name"]
    reset-to-upstream.sh
    setup-kb-local-repo.sh

## DESCPRITION
    This manual page documents the set of scripts in kb-tools (`create-article.sh`, `reset-to-upstream.sh`, and `setup-kb-local-repo.sh`)  
    They can be used to streamline the creation and publishing of our Knowledge Base articles. 


## OPTIONS
    -q, --question  Create article in question group
    -i, --issue     Create article in issue group
    -h, --howto     Create article in how-to group

## USAGE
    All tools are created to be run from the `kb-tools` directory and will create and manage the `support-kb` directory along side them.  

    +----------------------------------------+
    |                                        |
    |  knowlege-base-directory               |
    |                                        |
    |   +--------------+  +--------------+   |
    |   |              |  |              |   |
    |   |   kb-tools   |  |  support-kb  |   |
    |   |              |  |              |   |
    |   +--------------+  +--------------+   |
    |                                        |
    +----------------------------------------+
    
    
    1. Creat a directory for your knowledge base then from inside it, clone `kb-tools`
    2. cd into kb-tools
    3. Set configurations in `configs`
    4. ./setup-kb-local-repo.sh
    5. ./create-article.sh -q "What is kb-tools?"
    6. Write or paste in article, add attachments directory manually and fill with any needed attachments, then close editor when article is done
    7. Copy commands returned by create-article and paste in terminal.  You can run them all at once to push the article and clear your workspace, or evaluate and run one at a time.


### FILES
    configs  
      Stores all user specific configs.  
      Currently Author, Visability setting, Repo, and Upstream Repo.  
    
      *Todo: Visability will eventually be moved to an option for the main script.*
    
    
    create-article.sh  
      Takes an option to choose article category and a title for the article, encapsulated in quotes.  
      It will refresh the repo, create a feature branch, create the necessary directory, create \_\_article\_\_.yaml, copy in the appropriate article template, and opens it in your default editor.  **Note: you should add your attachments manually while writing the article or just remember to run `git add` for the directory before commiting and pushing**  
    
      *Todo: I plan on moving that to the config so you can choose your editor or leave it to use the default terminal.*  
    
      After you close the editor, `create-article.sh` will add the article's directory to your staging area, output commands you can copy and run directly in the terminal to comit and push your article to `origin`.  
    
    
    reset-to-upstream.sh  
      Reset your master branch to upstream and clear the slate for the next article.  
      Fetches upstream, checks out master, rests to upstream/master, pushes to origin master, git clean -fd to clear untracked files and folders
    
    setup-kb-local-repo.sh  
      Clones your Fork of the repo and sets upstream.  Refers to `configs` file for repo locations.
    
    
    
    
