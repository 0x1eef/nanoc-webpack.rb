## About

nanoc-webpack.rb is a [nanoc](https://github.com/nanoc/nanoc#readme) filter
that can compile nanoc content with [webpack](https://webpack.js.org/).
nanoc-webpack.rb intends to bring the benefits of JavaScript, TypeScript and
the webpack ecosystem to nanoc-powered websites. The filter expects to take
an entry point as its input, and produce a webpack bundle as its output.

## Examples

__app.ts__

In the the following example `app.ts` is forwarded to webpack, and then `app.js`
is written to disk:

``` ruby
# Rules
require "nanoc-webpack"
compile "/js/app.ts" do
  filter(:webpack)
  write("/js/app.js")
end
```

__Option: "depends_on"__

The filter supports a couple of options. The first option, "depends_on",
informs nanoc what other files the entry point imports or requires. When
a file being monitored by the "depend_on" option undergoes a change, nanoc
will initiate a recompilation of the entry point:

```ruby
# Rules
require "nanoc-webpack"
compile "/js/ReactApp.jsx" do
  filter(:webpack, depend_on: ["/js/lib", "/js/components", "/js/hooks"])
  write("/js/app.js")
end
```

__Option: "reject"__

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

## Requirements

nanoc-webpack.rb assumes that:

* A "node" executable is available in $PATH.
* [npm](https://www.npmjs.com) or [yarn](https://yarnpkg.com/) are used for
  package management.
* "webpack" / "webpack-cli" exist as dependencies in package.json.

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
gem "nanoc-webpack.rb", github: "0x1eef/nanoc-webpack.rb", tag: "v0.3.2"
gem "ryo.rb", github: "0x1eef/ryo.rb", tag: "v0.3.0"
```

## License

[BSD Zero Clause](https://choosealicense.com/licenses/0bsd/).
<br>
See [LICENSE](./LICENSE).
