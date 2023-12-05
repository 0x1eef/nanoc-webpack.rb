## About

nanoc-webpack.rb is a
[nanoc](https://nanoc.app)
filter
that integrates
[webpack](https://webpack.js.org/)
into nanoc-powered websites. The filter provides a bridge that
connects nanoc, and the JavaScript, TypeScript, and nodejs ecosystems.

## Examples

__app.ts__

The following example forwards the entry point `app.ts` to webpack, and
then writes the result of the webpack compilation to `app.js`.

``` ruby
# Rules
require "nanoc-webpack"
compile "/js/app.ts" do
  filter(:webpack)
  write("/js/app.js")
end
```

__Option: "depend_on"__

The `depend_on` option tells nanoc what files an entry point imports or requires.
When a file being tracked by the `depend_on` option undergoes a change, nanoc
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

The `depend_on` option can be combined with the `reject` option to exclude
certain files or directories from being tracked. For example, maybe you want
to track `/js/lib/` but not `/js/lib/foo/`:

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
gem "nanoc-webpack.rb", github: "0x1eef/nanoc-webpack.rb"
gem "ryo.rb", github: "0x1eef/ryo.rb"
```

## License

[BSD Zero Clause](https://choosealicense.com/licenses/0bsd/).
<br>
See [LICENSE](./LICENSE).
