# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cheat}
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chris Wanstrath"]
  s.date = %q{2010-07-24}
  s.default_executable = %q{cheat}
  s.description = %q{  cheat prints cheat sheets from cheat.errtheblog.com, a wiki-like
  repository of programming knowledge.
}
  s.email = %q{chris@ozmm.org}
  s.executables = ["cheat"]
  s.files = ["README", "LICENSE", "lib/ambition/init.rb", "lib/ambition/lib/ambition/count.rb", "lib/ambition/lib/ambition/enumerable.rb", "lib/ambition/lib/ambition/limit.rb", "lib/ambition/lib/ambition/order.rb", "lib/ambition/lib/ambition/processor.rb", "lib/ambition/lib/ambition/query.rb", "lib/ambition/lib/ambition/where.rb", "lib/ambition/lib/ambition.rb", "lib/ambition/lib/proc_to_ruby.rb", "lib/ambition/LICENSE", "lib/ambition/Rakefile", "lib/ambition/README", "lib/ambition/test/chaining_test.rb", "lib/ambition/test/count_test.rb", "lib/ambition/test/enumerable_test.rb", "lib/ambition/test/helper.rb", "lib/ambition/test/join_test.rb", "lib/ambition/test/limit_test.rb", "lib/ambition/test/order_test.rb", "lib/ambition/test/types_test.rb", "lib/ambition/test/where_test.rb", "lib/cheat/diffr.rb", "lib/cheat/responder.rb", "lib/cheat/rv_harness.rb", "lib/cheat/site.rb", "lib/cheat/version.rb", "lib/cheat/wrap.rb", "lib/cheat.rb", "bin/cheat"]
  s.homepage = %q{http://cheat.errtheblog.com}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{cheat prints cheat sheets from cheat.errtheblog.com}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
