Object.class_eval do
  def stub(method_name, options = {}, &block)
    proc = block || Proc.new do
      options[:return]
    end

    if self.is_a? Class
      define_method method_name, &proc
    else
      define_singleton_method method_name, &proc
    end
  end
end
