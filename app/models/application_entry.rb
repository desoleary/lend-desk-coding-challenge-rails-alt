class ApplicationEntry < SimpleRedisOrm::Entry

  class << self
    attr_writer :model_name

    def new(id:, **attributes)
      super(id: redis_key(id), **attributes)
    end

    def create(id:, **attributes)
      super(id: redis_key(id), **attributes)
    end

    def find(id)
      super(redis_key(id))
    end

    protected

    def model_name
      @model_name ||= name.underscore
    end

    private

    def redis_key(id)
      id = without_redis_key_prefix(id)
      "#{model_name}:#{id}"
    end
  end
end
