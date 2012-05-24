# Yamlファイル読込

# サーバ設定情報
SYSTEM_CONFIG = YAML.load_file(File.join(Rails.root, 'config/yamls', 'system_config.yml'))[Rails.env]

# 定数
CONST = YAML.load_file(File.join(Rails.root, 'config/yamls', 'const.yml'))