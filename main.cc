#include <iostream>
#include <sstream>
#include <string>

#include <sysexits.h>

#include <grammar.yy.hh>
#include <tokens.l.hh>
#include <location.hh>

using namespace Project;
using Location = location;

void Parser::error(Location const& location, const std::string& string) {
    std::cerr << location.begin.filename << ":" << location.begin.line << ":" << location.begin.column << ":" << string << std::endl;
    exit(EX_DATAERR);
}

int main(int argc, char* argv[]) {
    auto context = Context();
    if (argc == 2 && std::string(argv[1]) == "trace") {
        context.trace = 1;
    }

    auto stream = std::stringstream("4 + 2.3 * (6 + 2)");
    Lexer lexer = Project::Lexer(stream);


    Parser parser(&lexer, &context);

    try {
        parser.parse();
    } catch (const char* error) {
        std::cerr << "[CRITICAL] Unhandled parse issue: " << error << std::endl;
        return EX_SOFTWARE;
    }

    std::cout << "Result: " << context.result << std::endl;

    return EX_OK;
}