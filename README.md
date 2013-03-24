# Scatter

A deploy helper.

## Installation

`gem install scatter_deploy`

If your Gem directory is in your `PATH`, you'll now have access to the `scatter` command.  Run `scatter help` for an overview.

## Usage

You interact with Scatter through the `scatter` command.  You can see a basic overview with `scatter help`.

```
Tasks:
  scatter cap COMMAND   # Run arbitrary Capistrano commands.
  scatter deploy        # Run a deploy routine. This is the default task.
  scatter exec COMMAND  # Run arbitrary commands.
  scatter help [TASK]   # Describe available tasks or one specific task
  scatter version       # Show version.

Options:
  -d, [--directory=DIRECTORY]  # Specify a deploys directory.
                               # Default: /Users/evan/.deploys
  -p, [--project=PROJECT]      # Specify a project path, defaults to current Git repository root.
  -s, [--shared=SHARED]        # Use a deploy script in the __shared directory. The project path will automatically be passed as an argument
```

All commands take three optional flags, `--directory`, `--project`, and `--shared`.

## Flags

* `--directory`, `-d`: Specify the root of your deploys directory. Defaults to `~/.deploys`.
* `--project`, `-p`: Specify a path to a project (relative or absolute). Defaults to the root of the current Git repository, if one exists.  If you're not in a Git repository you *must* pass this argument.
* `--shared`, `-s`: Specify a shared deploy command to use instead of a project-specific script. The absolute project path will be passed as an argument to the command.

## Commands

### `scatter` or `scatter deploy`

Scatter's default task is `deploy`, so running `scatter deploy` is exactly the same as running `scatter`.  The `deploy` command will look first for an executable file called `deploy` in the project-specific deploy directory, then for a `Capfile`.  If it finds an executable, it will run it.  If no executable is found, but a `Capfile` is found, it will run `cap deploy`.

### `scatter cap COMMAND`

Let's you run arbitrary Capistrano commands, e.g. `scatter cap nginx:restart`.  All commands will be proxied to the project-specific deploy directory, which must contain a `Capfile` and config.

### `scatter exec COMMAND`

Let's you run arbitrary shell commands in the project-specific deploy directory, e.g. `scatter exec ls`.

## Examples

* `scatter`: Deploy the current project.
* `scatter -p projectname`: Deploy the project in `./projectname`.
* `scatter -p ~/projectname`: Deploy the project in your home directory's `projectname` directory.
* `scatter -s wp`: Deploy the current project by calling `~/.deploys/__shared/wp` and passing your current Git repository's root as an argument.

### WordPress

One of my use cases for Scatter is deploying WordPress plugins versioned with Git to WordPress.org, which uses Subversion.  I wrote a post on how I use Scatter to do it: [Git, WordPress plugins, and a bit of sanity: Scatter](http://evansolomon.me/notes/git-wordpress-plugins-and-a-bit-of-sanity-scatter/).
