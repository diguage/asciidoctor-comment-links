# frozen_string_literal: true

require 'time'

repo_url = 'https://github.com/diguage/asciidoctor-comment-links'
release_version = ENV['RELEASE_VERSION']
release_gem_version = ENV['RELEASE_GEM_VERSION']
release_date = Time.now.strftime '%Y-%m-%d'

version_file = Dir['lib/**/version.rb'].first
readme_file = 'README.adoc'
changelog_file = 'CHANGELOG.adoc'

version_contents = (File.readlines version_file, mode: 'r:UTF-8').map do |l|
  if l =~ /^\s*VERSION\s*=/
    l.sub %r/^\s*(VERSION\s*=\s*)(['"]).*?\2/ do
      %(#{$1}#{$2}#{release_gem_version}#{$2})
    end
  else
    l
  end
end

readme_contents = File.readlines readme_file, mode: 'r:UTF-8'
version_line = %(v#{release_version}, #{release_date}\n)
if (version_idx = readme_contents.index {|l| l =~ /^v\d+\.\d+\.\d+.*,\s*\d{4}-\d{2}-\d{2}/ })
  readme_contents[version_idx] = version_line
else
  title_idx = readme_contents.index {|l| l.start_with? '= ' }
  title_idx ? (readme_contents.insert title_idx + 1, version_line) : (readme_contents.unshift version_line)
end

changelog_contents = File.readlines changelog_file, mode: 'r:UTF-8'
last_release_idx = changelog_contents.index {|l| l =~ /^== v?\d/ }
previous_release_version = nil
if last_release_idx
  previous_release_version = changelog_contents[last_release_idx].match(%r/^== v?(\d\S+)/)[1]
end
details_line = "#{repo_url}/releases/tag/v#{release_version}[git tag]"
if previous_release_version
  details_line += " | #{repo_url}/compare/v#{previous_release_version}\\...v#{release_version}[full diff]"
end
release_block = [
  "== v#{release_version}\n",
  ?\n,
  ". _No changes since previous release._\n",
  ?\n,
  "=== Details\n",
  ?\n,
  "#{details_line}\n",
  ?\n,
]
if last_release_idx
  changelog_contents.insert last_release_idx, release_block.join
else
  changelog_contents << ?\n unless changelog_contents.empty? || changelog_contents.last.end_with?(?\n)
  changelog_contents.concat release_block
end

File.write version_file, version_contents.join, mode: 'w:UTF-8'
File.write readme_file, readme_contents.join, mode: 'w:UTF-8'
File.write changelog_file, changelog_contents.join, mode: 'w:UTF-8'
