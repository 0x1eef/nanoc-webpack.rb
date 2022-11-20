## About

nanoc-webpack.rb is a [nanoc](https://github.com/nanoc/nanoc#readme) filter
that can compile textual items with [webpack](https://webpack.js.org/).
nanoc-webpack.rb aims to bring the benefits of JavaScript, TypeScript and
the webpack ecosystem to nanoc-powered websites.

## Requirements

nanoc-webpack.rb makes a few assumptions:

* A "node" executable is available in `$PATH`.

* [npm](https://www.npmjs.com) or [yarn](https://yarnpkg.com/) are being used
  for package management.

* `webpack` exists as a dependency in `package.json`.

## Examples

### Introduction

The basic principle that nanoc-webpack.rb is built on is that it will take an
entry point as its input, and produce a webpack bundle as its output. Configuration
that goes beyond that happens in `webpack.config.js`.

When [TypeScript](https://www.typescriptlang.org/) or [babel](https://babeljs.io/)
are being used then it will often make sense to have configuration files for TypeScript
and babel as well.

### JavaScript

The following example demonstrates how to compile a JavaScript file with webpack:

```ruby
# Rules
require "nanoc-webpack"
compile "/js/app.js" do
  filter(:webpack)
  write("/js/app.js")
end
```

### TypeScript

The following example demonstrates how to compile a TypeScript file with webpack:

``` ruby
# Rules
require "nanoc-webpack"
compile "/js/app.ts" do
  filter(:webpack)
  write("/js/app.js")
end
```

### React (JSX)

The following example demonstrates how to compile a React component with webpack:

```ruby
# Rules
require "nanoc-webpack"
compile "/js/ReactApp.jsx" do
  filter(:webpack)
  write("/js/app.js")
end
```

### Track dependencies

Typically nanoc will only be aware of an entry point, and remain unaware of the
files it requires, or imports.

The `depend_on` filter option can be used to make nanoc aware of files that an
entry point requires, or imports. When one of those files change, nanoc will recompile
the entry point with webpack.

It is recommended to keep entry points in a directory separate to the files they depend
on. It is worth spending some time thinking about a directory layout that works best
when a site can have multiple entry points that have distinct, and/or shared dependencies.

With that said, the following example demonstrates how the `depend_on` option might be used:

```ruby
# Rules
require "nanoc-webpack"
compile "/js/ReactApp.jsx" do
  filter(:webpack, depend_on: ["/js/{lib,components,hooks}/**/*.jsx"])
  write("/js/app.js")
end
```

## Sources

* [Source code (GitHub)](https://github.com/0x1eef/nanoc-webpack.rb)
* [Source code (GitLab)](https://gitlab.com/0x1eef/nanoc-webpack.rb)

## Install

nanoc-webpack.rb is available as a RubyGem:

    gem install nanoc-webpack.rb

## License

This project is released under the terms of the MIT license. <br>
See [./LICENSE.txt](./LICENSE.txt) for details.
