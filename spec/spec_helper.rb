# frozen_string_literal: true

require 'asciidoctor'
require 'asciidoctor-comment-links'
require 'asciidoctor-comment-links/version'
require 'shellwords'

RSpec.configure do
  def fixtures_dir
    File.join __dir__, 'fixtures'
  end

  def fixture_file path
    File.join fixtures_dir, path
  end

  def ruby
    cmd = Shellwords.escape File.join RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name']
    lib_dir = Shellwords.escape File.expand_path '../lib', __dir__
    %(#{cmd} -I#{lib_dir})
  end

  def with_memory_logger level = nil
    old_logger, logger = Asciidoctor::LoggerManager.logger, Asciidoctor::MemoryLogger.new
    logger.level = level if level
    Asciidoctor::LoggerManager.logger = logger
    yield logger
  ensure
    Asciidoctor::LoggerManager.logger = old_logger
  end
end
