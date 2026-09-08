# Novix OS

<p align="center">
  <strong>Минималистичная 64-битная операционная система</strong><br>
  Bootloader → Kernel → Drivers → Libs
</p>

---

## 📋 О проекте

**Novix OS** — это лёгкая, гибкая и расширяемая 64-битная операционная система, ориентированная на продвинутых пользователей и разработчиков. Система построена на монолитном ядре с поддержкой управления памятью, планировщиком процессов и базовыми драйверами устройств.

Проект вдохновлён философией Linux — минимализм, контроль и свобода кастомизации. Пользовательский интерфейс — консоль с поддержкой скриптов и автоматизации. Графические оболочки и окружения создаются самими пользователями.

## 🏗️ Архитектура

```
┌─────────────────────────────────────────┐
│              Novix OS                   │
├─────────────┬───────────┬───────────────┤
│   Boot      │  Kernel   │   Drivers     │
│  16→32→64   │  Memory   │   VGA         │
│  GDT/Paging │  VMM/PMM  │   Keyboard    │
│  A20/Long   │  Scheduler│   Serial      │
│  Mode       │  Syscalls │               │
├─────────────┴───────────┴───────────────┤
│              Libs                       │
│   stdio · string · stdlib               │
├─────────────────────────────────────────┤
│           Plugin System (xudo)          │
│   hello-world · bootgui · repos.conf    │
└─────────────────────────────────────────┘
```

### 📦 Компоненты

| Модуль | Описание |
|--------|----------|
| **Bootloader** | 16-bit → 32-bit → 64-bit переход: GDT, A20, paging, long mode |
| **Kernel** | Монолитное 64-битное ядро, точка входа `_start` → `kernel_main()` |
| **PMM** | Physical Memory Manager — bitmap-аллокатор физических страниц |
| **VMM** | Virtual Memory Manager — 4-уровневая иерархия таблиц страниц (PML4→PDPT→PD→PT) |
| **Scheduler** | Планировщик процессов с приоритетами (до 64 процессов) |
| **Syscalls** | Системные вызовы (read, write, open, close, exit) |
| **VGA** | Текстовый режим 80×25, цвета, курсор |
| **Keyboard** | Драйвер клавиатуры (PS/2, scancode → ASCII) |
| **Serial** | Последовательный порт (COM1, 0x3F8) |
| **Libs** | freestanding-реализации string.h, stdio.h, stdlib.h |
| **xudo** | Плагин-система для управления пакетами и расширениями |

## 🛠️ Сборка и запуск

### 📝 Требования

- **GCC** (MinGW на Windows / gcc на Linux)
- **NASM** (ассемблер)
- **GNU Make**
- **QEMU** (qemu-system-x86_64)

### 🚀 Команды

```bash
# Очистка и сборка
make clean && make

# Запуск в QEMU
make run
```

### 📁 Структура проекта

```
Novix/
├── boot/
│   ├── boot.asm          # Bootloader (16→32→64 бит)
│   └── link.ld           # Линкер-скрипт
├── kernel/
│   ├── entry.asm         # Точка входа в 64-битном режиме
│   ├── kernel.c          # Главная функция kernel_main()
│   ├── memory/
│   │   ├── pmm.c/.h      # Physical Memory Manager
│   │   └── vmm.c/.h      # Virtual Memory Manager
│   ├── process/
│   │   └── scheduler.c/.h # Планировщик процессов
│   └── syscall/
│       └── syscall.c/.h   # Системные вызовы
├── drivers/
│   ├── vga/vga.c         # VGA текстовый драйвер
│   ├── keyboard/keyboard.c # Драйвер клавиатуры
│   └── serial/serial.c   # COM-порт
├── lib/
│   ├── stdio.c           # printf, putchar, puts
│   ├── string.c          # memcpy, memset, strcmp, ...
│   └── stdlib.c          # malloc, free, atoi
├── include/
│   ├── kernel/           # Заголовки ядра и драйверов
│   └── lib/              # Заголовки библиотек
├── plugins/              # Плагины (xudo)
├── etc/xudo/             # Конфигурация плагин-системы
├── docs/                 # Документация
└── Makefile
```

## 📜 Лицензия

Проект распространяется под лицензией **GNU General Public License v2**. См. [LICENSE](LICENSE).

## 👥 Разработчики

| Имя | Роль | Вклад |
|-----|------|-------|
| **Рома Стеганцов** | Создатель, архитектор, основной разработчик | ~87% |
| **Mistral AI** | Сборка, баг-фиксы, bootloader, линкер, оптимизация | ~13% |

---

<p align="center">
  Novix OS © 2025 — Built with passion for low-level development
</p>