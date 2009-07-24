class Object
  def message(message)
    if defined? @env.stdout
      if not defined? @env.options.verbose or @env.options.verbose
        report(@env.stdout, message)
      end
    else
      report(STDOUT, message)
    end
  end
  alias msg message

  def error(message)
    if defined? @env.stderr
      if not defined? @env.options.quiet or not @env.options.quiet
        report(@env.stderr, message)
      end
    else
      report(STDERR, message)
    end
  end
  alias err error

  def report(ios, message)
    if ios.is_a?(IO) and
         message.is_a?(String) then
      ios.puts(message)
    end
  end
end