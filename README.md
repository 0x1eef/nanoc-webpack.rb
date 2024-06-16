## About

nanoc-webpack.rb is a
[nanoc](https://nanoc.app)
filter that adds
[webpack](https://webpack.js.org/)
support to nanoc. <br>
The filter connects nanoc to the the JavaScript, TypeScript,
and nodejs ecosystems.

## Examples

**Defaults**

The following example forwards the entry point `/js/main/App.tsx`
to webpack. <br> The result is then written to `/js/main/app.js`:

``` ruby
# Rules
require "nanoc-webpack"
compile "/js/main/App.tsx" do
  filter(:webpack)
  write("/js/main/app.js")
end
```

**Option: depend_on**

When a file or directory tracked by the `depend_on` option
is observed to have changed, nanoc will initiate a recompilation
of the entry point:

```ruby
# Rules
require "nanoc-webpack"
compile "/js/main/App.tsx" do
  filter(:webpack, depend_on: ["/js/lib", "/js/components", "/js/hooks"])
  write("/js/main/app.js")
end
```

**Option: reject**

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
  write("/js/main/app.js")
end
```

**Option: argv**

The `argv` option forwards command line arguments directly
to the webpack executable. <br>
[Nanoc::Webpack.default_argv](https://0x1eef.github.io/x/nanoc-webpack.rb/Nanoc/Webpack.html#default_argv-class_method)
returns the default command line arguments forwarded to webpack:

```ruby
# Rules
require "nanoc-webpack"
compile "/js/main/App.tsx" do
  filter(:webpack, argv: ["--config", "webpack.production.js"])
  write("/js/main/app.js")
end
```

## Install

nanoc-webpack.rb can be installed via rubygems.org:

    gem install nanoc-webpack.rb

## See also

* [0x1eef/terry.reflectslight.io](https://github.com/0x1eef/terry.reflectslight.io) <br>
  A simple nanoc application that uses nanoc-webpack.rb

## Sources

* [GitHub](https://github.com/0x1eef/nanoc-webpack.rb#readme)
* [GitLab](https://gitlab.com/0x1eef/nanoc-webpack.rb#about)

## License

[BSD Zero Clause](https://choosealicense.com/licenses/0bsd/)
<br>
See [LICENSE](./LICENSE)
