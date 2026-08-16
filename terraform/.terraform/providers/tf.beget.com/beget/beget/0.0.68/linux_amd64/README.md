# Terraform Provider Beget

Terraform провайдер для управления облачными сервисами Beget. Проект создан на основе официального [Terraform Plugin Framework](https://github.com/hashicorp/terraform-provider-scaffolding-framework).

Провайдер публикуется в [self-hosted registry](https://gitlab.beget.ru/cloud/terraform-provider-endpoint) и документация синхронизируется в  наш [GitHub](https://github.com/LTD-Beget/terraform-provider-beget).

## Требования

- [Go](https://golang.org/doc/install) >= 1.24
- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.0
- [golangci-lint](https://golangci-lint.run/docs/welcome/install/local/)

## Структура проекта

```
terraform-provider-beget/
├── internal/             # Реализация провайдера (ресурсы и дата-сурсы)
├── examples/             # Примеры использования (встраиваются в документацию)
│   ├── resources/        # Примеры ресурсов
│   └── data-sources/     # Примеры дата-сурсов
├── templates/            # Шаблоны документации (.md.tmpl)
│   ├── resources/        # Шаблоны для ресурсов
│   └── data-sources/     # Шаблоны для дата-сурсов
├── docs/                 # Сгенерированная документация (публикуется на github)
├── tools/                # Тулзы для генерации документации и копирайтов
└── GNUmakefile           # Makefile :)
```

## Локальная сборка и разработка

### Сборка провайдера

```bash
make install
```

Можно запускать просто `make` - тогда выполнится сразу: форматирование кода (`fmt`), линтинг (`lint`), сборка (`install`) и генерацию документации (`generate`).

Собранный бинарник будет находиться в `$GOPATH/bin/`.

### Использование локально собранного провайдера

В файл `~/.terraformrc` нужно положить:

```hcl
provider_installation {
  dev_overrides {
    "tf.beget.com/beget/beget" = "/path/to/gopath/bin"
  }
  direct {}
}
```

Где в качестве `/path/to/gopath/bin` указать путь до каталога с бинарем провайдера, по умолчанию это `$GOPATH/bin`.

Пример полного `~/.terraformrc`:

```hcl
provider_installation {
  dev_overrides {
    "tf.beget.com/beget/beget" = "/Users/kirill/go/bin"
  }
  direct {}
}
```

В Terraform конфигурации нужно использовать тот же source, что и для production:

```hcl
terraform {
  required_providers {
    beget = {
      source  = "tf.beget.com/beget/beget"
    }
  }
}
```

В этом случае terraform будет использовать локальный бинарь и не будет скачивать провайдер с registry и проверять хеш-сумму.

#### Если в ~/.terraformrc уже есть блок direct

Если в файле ~/.terraformrc уже есть объявленный блок direct (например, используются зеркала репозиториев Hashicorp) - менять его не требуется, достаточно добавить блок `dev_overrides` в конфигурацию.

Пример файла до изменений:

```hcl
provider_installation {
  network_mirror {
    url     = "https://nm.tf.org.ru/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```

Пример файла после изменений:

```hcl
provider_installation {
  dev_overrides {
    "tf.beget.com/beget/beget" = "/Users/kirill/go/bin"
  }
  network_mirror {
    url     = "https://nm.tf.org.ru/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```

## Генерация и обновление документации

Документация генерируется из шаблонов (`.md.tmpl`) и примеров (`.tf` файлов) с помощью `terraform-plugin-docs`.

### Работа с документацией

1. **Шаблоны** находятся в `templates/`:
   - `templates/resources/*.md.tmpl` — шаблоны для ресурсов
   - `templates/data-sources/*.md.tmpl` — шаблоны для дата-сурсов

2. **Примеры** находятся в `examples/`:
   - `examples/resources/beget_<resource_name>/` — примеры использования ресурсов
   - `examples/data-sources/beget_<data_source_name>/` — примеры использования дата-сурсов

3. **Генерация документации**:

```bash
make generate
```

Эта команда:
- Форматирует примеры Terraform (`terraform fmt`)
- Генерирует документацию из шаблонов и примеров
- Сохраняет результат в `docs/resources/` и `docs/data-sources/`

Сгенерированные файлы в `docs/` **НЕЛЬЗЯ** редактировать вручную — они автоматически обновляются при запуске `make generate`.

## Релиз новой версии

Код провайдера находится тут https://gitlab.beget.ru/kzhuykov/terraform-provider

### Подготовка к релизу

1. **Перед коммитом** выполни:

```bash
make
```

Это запустит:
- Форматирование кода
- Линтинг
- Сборку
- Генерацию документации
- Unit-тесты

2. **Если документация обновилась**, добавь изменения в свой коммит.

### Создание релиза

1. Вешаем тег как обычно

2. В пайплайнах:
   - Соберутся бинарники для [всех указанных платформ](https://gitlab.beget.ru/kzhuykov/terraform-provider/-/blob/master/.goreleaser.yml?ref_type=heads#L32) с помощью [GoReleaser](https://goreleaser.com)
   - Подпишется релиз GPG-ключом (используются `GPG_PRIVATE_KEY` и `GPG_FINGERPRINT` из CI/CD [переменных проекта](https://gitlab.beget.ru/kzhuykov/terraform-provider/-/settings/ci_cd))
   - Загрузятся бинарники в self-hosted registry
   - Обновится документация в GitHub репозитории
   - Будет создан новый [Release в gitlab](https://gitlab.beget.ru/kzhuykov/terraform-provider/-/releases)

## Дополнительные ресурсы

- [Документация провайдера](https://github.com/LTD-Beget/terraform-provider-beget)
- [Terraform Plugin Framework](https://github.com/hashicorp/terraform-plugin-framework)
