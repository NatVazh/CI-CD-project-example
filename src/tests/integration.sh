#!/bin/bash

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

TESTS_PASSED=0
TESTS_FAILED=0

run_test() {
    local test_name="$1"
    local command="$2"
    local expected_output_pattern="$3"
    local expected_exit_code="${4:-0}"

    echo -e "${YELLOW}Запуск: ${test_name}${NC}"

    local output
    local exit_code

    output=$(eval "$command" 2>&1) || exit_code=$?
    exit_code=${exit_code:-0}

    if [[ $exit_code -eq $expected_exit_code ]] && 
       [[ "$output" =~ $expected_output_pattern ]]; then
        echo -e "${GREEN}✅ ПРОЙДЕН: ${test_name}${NC}"
        ((TESTS_PASSED++))
        return 0
    else
        echo -e "${RED}❌ ПРОВАЛЕН: ${test_name}${NC}"
        echo "  Команда: $command"
        echo "  Ожидаемый код: $expected_exit_code, Получен: $exit_code"
        echo "  Ожидаемый вывод: '$expected_output_pattern'"
        echo "  Фактический вывод:"
        echo "  ---"
        echo "$output"
        echo "  ---"
        ((TESTS_FAILED++))
        return 1
    fi
}

cleanup() {
    echo -e "\n${YELLOW}=== Итоги тестирования ===${NC}"
    echo -e "${GREEN}ТЕСТОВ ПРОЙДЕНО: ${TESTS_PASSED}${NC}"
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "${GREEN}ТЕСТОВ ПРОВАЛЕНО: ${TESTS_FAILED}${NC}"
        echo -e "${GREEN}🎉 Все интеграционные тесты пройдены успешно!${NC}"
        exit 0
    else
        echo -e "${RED}ТЕСТОВ ПРОВАЛЕНО: ${TESTS_FAILED}${NC}"
        echo -e "${RED}❌ Некоторые тесты провалены!${NC}"
        exit 1
    fi
}

trap cleanup EXIT

echo -e "${YELLOW}=== Запуск интеграционных тестов ===${NC}"
echo "Тестируемое приложение: $(which do-app)"

run_test "Валидный ввод: вариант 1" "do-app 1" "Learning to Linux" 0 || true
run_test "Валидный ввод: вариант 2" "do-app 2" "Learning to work with Network" 0 || true
run_test "Валидный ввод: вариант 3" "do-app 3" "Learning to Monitoring" 0 || true
run_test "Валидный ввод: вариант 4" "do-app 4" "Learning to extra Monitoring" 0 || true
run_test "Валидный ввод: вариант 5" "do-app 5" "Learning to Docker" 0 || true
run_test "Валидный ввод: вариант 6" "do-app 6" "Learning to CI/CD" 0 || true

run_test "Нет аргументов" "do-app" "Bad number of arguments" 255
run_test "Слишком много аргументов" "do-app 1 2" "Bad number of arguments" 255

run_test "Невалидное число: 0" "do-app 0" "Bad number" 254
run_test "Невалидное число: 7" "do-app 7" "Bad number" 254
run_test "Невалидное число: 99" "do-app 99" "Bad number" 254
run_test "Невалидное число: -1" "do-app -1" "Bad number" 254
run_test "Нечисловое значение: строка" "do-app abc" "Bad number" 254
run_test "Нечисловое значение: пустая строка" "do-app ''" "Bad number" 254
