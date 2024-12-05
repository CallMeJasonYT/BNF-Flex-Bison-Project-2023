# Flex-Bison Parser Project
This project focuses on developing a robust lexical analyzer and syntax parser using Flex and Bison. It is designed to process structured input files, validate syntax, and generate meaningful outputs based on predefined grammar rules. 
The project simulates the workflow of a compiler's front-end, highlighting essential concepts in lexical analysis and parsing. It was created as part of a university assignment in compiler construction.

## Authors

- [@CallMeJasonYT](https://github.com/CallMeJasonYT)
- [@Roumpini21](https://github.com/Roumpini21)

## Features
- Lexical Analysis: Implements a lexical analyzer using Flex to tokenize input files according to predefined patterns.
- Syntax Parsing: Leverages Bison to parse tokens and validate the structure of input files against a formal grammar.
- BNF Grammar Definition: Uses a Backus-Naur Form (BNF) definition to define the syntax rules for parsing.
- Error Handling: Provides detailed error messages for invalid syntax or lexical structures.
- Test Suite: Includes multiple test cases to verify correctness under various scenarios (valid, invalid, and edge cases).

## Tech Stack
Core Technologies: Flex, Bison, C/C++

## Installation

- Install Flex and Bison on your system:
```
sudo apt-get install flex bison
```

- Clone this repository:
```
git clone https://github.com/YourGitHubUsername/Flex-Bison-Parser-Project.git
cd Flex-Bison-Parser-Project
```

- Compile the parser:
```
bison -d syntax.y
flex vocabulary.l
gcc -o myParser syntax.tab.c lex.yy.c -lfl
```

## Usage
- Run the parser on a test file:
```
./myParser < test_file.txt
```

- Use the provided test cases to validate your implementation:

Valid inputs: comments_accept.txt, erotima1_a.txt, etc.
Invalid inputs: comments_fail.txt, erotima1_f.txt, etc.
