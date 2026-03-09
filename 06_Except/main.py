def input_int(prompt):
    while True:
        try:
            number = int(input(prompt))
            return number
        except ValueError:
            print("정수를 입력하세요.")


if __name__ == "__main__":
    result = input_int("숫자를 입력하세요: ")
    print(f"입력된 정수: {result}")