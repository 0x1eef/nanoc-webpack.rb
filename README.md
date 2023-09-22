## About

nanoc-webpack.rb is a [nanoc](https://github.com/nanoc/nanoc#readme) filter
that can compile nanoc content with [webpack](https://webpack.js.org/).
nanoc-webpack.rb intends to bring the benefits of JavaScript, TypeScript and
the webpack ecosystem to nanoc-powered websites. The filter expects to take
an entry point as its input, and produce a webpack bundle as its output.

## Requirements

nanoc-webpack.rb assumes that:

* A "node" executable is available in $PATH.
* [npm](https://www.npmjs.com) or [yarn](https://yarnpkg.com/) are used for
  package management.
* "webpack" exists as a dependency in package.json.

## Examples

### TypeScript

An example of how to compile a TypeScript file with webpack:

``` ruby
# Rules
require "nanoc-webpack"
compile "/js/app.ts" do
  filter(:webpack)
  write("/js/app.js")
end
```
### React

An example of how to compile a React component with webpack:

```ruby
# Rules
require "nanoc-webpack"
compile "/js/ReactApp.jsx" do
  filter(:webpack)
  write("/js/app.js")
end
```

### Filter options

The purpose of the "depend_on" option is to inform nanoc about the
files required or imported by an entry point. When a file, which
is being monitored by the "depend_on" option, undergoes a change,
nanoc will initiate a recompilation of the entry point.

The "depend_on" option can receive an array of paths. If a path points
to a directory, the directory is traversed recursively to locate files
and potentially other directories. It also supports glob patterns.
The following example demonstrates the "depend_on" option:

```ruby
# Rules
require "nanoc-webpack"
compile "/js/ReactApp.jsx" do
  filter(:webpack, depend_on: ["/js/lib", "/js/components", "/js/hooks"])
  write("/js/app.js")
end
```

The "depend_on" option can be combined with the "reject" option to exclude
certain files or directories. For example, you might want to monitor `/js/lib/`
but not include one of the directories within `/js/lib/`:

```ruby
# Rules
require "nanoc-webpack"
compile "/js/ReactApp.jsx" do
  filter :webpack,
         depend_on: ["/js/lib", "/js/components", "/js/hooks"],
         reject: proc { |path| path.start_with?("/js/lib/foo/") }
  write("/js/app.js")
end
```

## Sources

* [Source code (GitHub)](https://github.com/0x1eef/nanoc-webpack.rb)
* [Source code (GitLab)](https://gitlab.com/0x1eef/nanoc-webpack.rb)

## <a id='install'>Install</a>

nanoc-webpack.rb is distributed as a RubyGem through its git repositories. <br>
[GitHub](https://github.com/0x1eef/nanoc-webpack.rb),
and
[GitLab](https://gitlab.com/0x1eef/nanoc-webpack.rb)
are available as sources.

**Gemfile**

```ruby
gem "nanoc-webpack.rb", github: "0x1eef/nanoc-webpack.rb", tag: "v0.2.0"
gem "ryo.rb", github: "0x1eef/ryo.rb", tag: "v0.3.0"
```

## License

This project is released under the terms of the MIT license. <br>
See [./LICENSE.txt](./LICENSE.txt) for details.
