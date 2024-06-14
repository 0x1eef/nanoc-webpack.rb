# frozen_string_literal: true

require_relative "setup"
RSpec.describe Nanoc::Webpack::Filter do
  let(:paths) { ["/1", "/1/1.txt", "/1/2", "/1/2/1.txt"] }
  let(:root) { File.join("spec", "fakefs", "content") }
  let(:reject) { nil }
  let(:item) do
    Ryo.from(
      identifier: {to_s: "test.ts"},
      attributes: {content_filename: "test.ts"}
    )
  end
  let(:items) do
    paths.each_with_object({}) { _2[_1] = _1 }
  end
  let(:config) do
    Ryo.from(
      each: {to_h: {data_sources: [{content_dir: root}]}},
      data_sources: [{content_dir: root}]
    )
  end
  let(:filter) do
    Nanoc::Filter
      .named!(:webpack)
      .new(item:, items:, config:)
  end
  include FileUtils

  context "when given dependables" do
    subject { filter.dependable(paths: target, reject:) }

    before do
      mkdir_p(root)
      paths.each do
        path = File.join(root, _1)
        File.extname(path).empty? ? mkdir_p(path) : touch(path)
      end
    end

    after { rm_rf(root) }

    context "when the directory depth is 2" do
      context "when given /1 as a path" do
        let(:target) { "/1" }
        it { is_expected.to contain_exactly("/1/1.txt", "/1/2/1.txt") }
      end

      context "when given /1/2 as a path" do
        let(:target) { "/1/2" }
        it { is_expected.to contain_exactly("/1/2/1.txt") }
      end
    end

    context "when the directory depth is 5" do
      let(:paths) { super().concat(["/1/2/3/4/5", "/1/2/3/4/5/1.txt"]) }

      context "when given /1 as a path" do
        let(:target) { "/1" }
        it do
          is_expected.to contain_exactly(
                           "/1/1.txt",
                           "/1/2/1.txt",
                           "/1/2/3/4/5/1.txt"
                         )
        end
      end

      context "when given /1/2 as a path" do
        let(:target) { "/1/2" }
        it { is_expected.to contain_exactly("/1/2/1.txt", "/1/2/3/4/5/1.txt") }
      end

      context "when given /1/2/3 as a path" do
        let(:target) { "/1/2/3" }
        it { is_expected.to contain_exactly("/1/2/3/4/5/1.txt") }
      end

      context "when depth 5 has descendant directories" do
        let(:paths) do
          super().concat([
                           "/1/2/3/4/5/a", "/1/2/3/4/5/a/a.txt",
                           "/1/2/3/4/5/b", "/1/2/3/4/5/b/b.txt",
                           "/1/2/3/4/5/c", "/1/2/3/4/5/c/c.txt"
                         ])
        end

        context "when given /1 as a path" do
          let(:target) { "/1" }
          it do
            is_expected.to contain_exactly(
                             "/1/1.txt", "/1/2/1.txt", "/1/2/3/4/5/1.txt",
                             "/1/2/3/4/5/a/a.txt", "/1/2/3/4/5/b/b.txt",
                             "/1/2/3/4/5/c/c.txt"
                           )
          end
        end
      end
    end

    context "when one or more directories are excluded" do
      let(:paths) { super().concat(["/2/3", "/2/3/1.txt", "/3/4", "/3/4/1.txt"]) }

      context "when the target is [!12]" do
        let(:target) { "/[!12]/" }
        it { is_expected.to contain_exactly("/3/4/1.txt") }
      end

      context "when the reject filter is used" do
        let(:paths) do
          ["/lib/WebPackage/", "/lib/WebPackage/foo.ts",
           "/lib/Web/", "/lib/Web/foo.ts",
           "/lib/foo/", "/lib/foo/foo.ts"]
        end
        let(:target) { "/lib/" }
        let(:reject) { proc { |path| path.include?("WebPackage") } }

        it do
          is_expected.to contain_exactly("/lib/Web/foo.ts", "/lib/foo/foo.ts")
        end
      end
    end
  end

  context "when nodejs is executed" do
    let(:cmdline) do
      [
        "--entry", File.join(Dir.getwd, "test.ts"),
        "--output-path", instance_of(String),
        "--output-filename", instance_of(String)
      ]
    end

    context "with default arguments" do
      it "executes nodejs" do
        expect(filter).to receive(:cmd).with(
                            "node",
                            "./node_modules/webpack/bin/webpack.js",
                            *cmdline,
                          ).and_return(Ryo('success?' => true))
        filter.run(item)
      end
    end

    context "with --no-cache" do
      it "executes nodejs with an argument" do
        expect(filter).to receive(:cmd).with(
                            "node",
                            "./node_modules/webpack/bin/webpack.js",
                            "--no-cache",
                            *cmdline,
                          ).and_return(Ryo('success?' => true))
        filter.run(item, argv: ["--no-cache"])
      end
    end
  end
end
