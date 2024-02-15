## About

nanoc-webpack.rb is a
[nanoc](https://nanoc.app)
filter
that integrates
[webpack](https://webpack.js.org/)
into nanoc-powered websites. The filter provides a bridge that
connects nanoc, and the JavaScript, TypeScript, and nodejs ecosystems.

## Examples

### Defaults

#### /js/main/App.tsx

The following example forwards the entry point `/js/main/App.tsx` to webpack,
and then writes the result to `/js/app.js`. This example and all the other
examples assume that the files `webpack.config.js`, `tsconfig.json`, and
`package.json` already exist at the root of the project:

``` ruby
# Rules
require "nanoc-webpack"
compile "/js/main/App.tsx" do
  filter(:webpack)
  write("/js/app.js")
end
```

### Options

#### Option: "depend_on"

The `depend_on` option tells nanoc what files an entry point imports or requires.
When a file being tracked by the `depend_on` option undergoes a change, nanoc
will initiate a recompilation of the entry point:

```ruby
# Rules
require "nanoc-webpack"
compile "/js/main/App.tsx" do
  filter(:webpack, depend_on: ["/js/lib", "/js/components", "/js/hooks"])
  write("/js/app.js")
end
```

#### Option: "reject"

The `depend_on` option can be combined with the `reject` option to exclude
certain files or directories from being tracked. For example, maybe you want
to track `/js/lib/` but not `/js/lib/foo/`:

```ruby
# Rules
require "nanoc-webpack"
compile "/js/main/App.tsx" do
  filter :webpack,
         depend_on: ["/js/lib", "/js/components", "/js/hooks"],
         reject: proc { |path| path.start_with?("/js/lib/foo/") }
  write("/js/app.js")
end
```

#### Option: "args"

The `args` option can be used to forward command-line options directly
to the webpack executable.
<br>
`$ webpack build --help verbose` provides a list of all available options,
and
[Nanoc::Webpack.default_options](https://0x1eef.github.io/x/nanoc-webpack.rb/Nanoc/Webpack.html#default_options-class_method)
returns the default options nanoc-webpack.rb will forward to webpack:

```ruby
# Rules
require "nanoc-webpack"
compile "/js/main/App.tsx" do
  filter :webpack, args: {"--no-stats" => true}
  write("/js/app.js")
end
```


## Requirements

nanoc-webpack.rb assumes that:

* A "node" executable is available in $PATH.
* "webpack" / "webpack-cli" exist as dependencies in package.json.

## Sources

* [Source code (GitHub)](https://github.com/0x1eef/nanoc-webpack.rb)
* [Source code (GitLab)](https://gitlab.com/0x1eef/nanoc-webpack.rb)

## <a id='install'>Install</a>

**Git**

nanoc-webpack.rb is distributed as a RubyGem through its git repositories. <br>
[GitHub](https://github.com/0x1eef/nanoc-webpack.rb),
and
[GitLab](https://gitlab.com/0x1eef/nanoc-webpack.rb)
are available as sources.

```ruby
# Gemfile
gem "nanoc-webpack.rb", github: "0x1eef/nanoc-webpack.rb"
```

**Rubygems.org**

nanoc-webpack.rb can also be installed via rubygems.org.

    gem install nanoc-webpack.rb

## License

[BSD Zero Clause](https://choosealicense.com/licenses/0bsd/).
<br>
See [LICENSE](./LICENSE).
