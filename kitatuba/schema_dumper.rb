require 'stringio'
require 'active_support/core_ext/big_decimal'


module ActiveRecord
  class SchemaDumper
    private_class_method :new
    
    
    ##
    # :singleton-method:
    # A list of tables which should not be dumped to the schema.
    # Acceptable values are string as well ass regexp.
    # This setting is only used if ActiveRecord::Base.schama_format  == :ruby
    
    # cattr_accessor アクセッサー設定メソッド
    # STDOUT 標準出力
    
    cattr_accessor :ignore_tables
    @@ignore_tables = []
    
    def self.dump(connection=ActiveRecord::Base.connection, stream=STDOUT)
      new(connection).dump(stream)
      stream
    end
    
    
  end
    
end
