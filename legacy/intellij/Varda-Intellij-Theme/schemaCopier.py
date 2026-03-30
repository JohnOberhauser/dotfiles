import re

def replace_text_in_file(
        input_file,
        output_file,
        theme_name,
        white,
        black,
        grey1,
        grey2,
        grey3,
        grey4,
        grey5,
        grey6,
        primary,
        primary_alt,
        secondary,
        warning,
        error,
        success,
        vcs_modified
):
    try:
        with open(input_file, 'r') as file:
            file_data = file.read()

        # Replace the text
        file_data = re.sub(r"Varda", theme_name, file_data, flags=re.IGNORECASE)
        # white
        file_data = re.sub(r"D0EBEE", white, file_data, flags=re.IGNORECASE)
        # black
        file_data = re.sub(r"0C0E11", black, file_data, flags=re.IGNORECASE)
        file_data = re.sub(r"C0E11", black, file_data, flags=re.IGNORECASE)
        # greys
        file_data = re.sub(r"121519", grey1, file_data, flags=re.IGNORECASE)
        file_data = re.sub(r"171B21", grey2, file_data, flags=re.IGNORECASE)
        file_data = re.sub(r"1C2128", grey3, file_data, flags=re.IGNORECASE)
        file_data = re.sub(r"222830", grey4, file_data, flags=re.IGNORECASE)
        file_data = re.sub(r"272E38", grey5, file_data, flags=re.IGNORECASE)
        file_data = re.sub(r"38414F", grey6, file_data, flags=re.IGNORECASE)
        # primary
        file_data = re.sub(r"52677C", primary, file_data, flags=re.IGNORECASE)
        # primary alt
        file_data = re.sub(r"8295A9", primary_alt, file_data, flags=re.IGNORECASE)
        # secondary
        file_data = re.sub(r"665276", secondary, file_data, flags=re.IGNORECASE)
        # tertiary / warning / yellow
        file_data = re.sub(r"C78C56", warning, file_data, flags=re.IGNORECASE)
        # error / red
        file_data = re.sub(r"733447", error, file_data, flags=re.IGNORECASE)
        # success / green
        file_data = re.sub(r"257B76", success, file_data, flags=re.IGNORECASE)
        # VCS modified
        file_data = re.sub(
            r'<option name="FILESTATUS_MODIFIED" value="A7C080" />',
            '<option name="FILESTATUS_MODIFIED" value="{}" />'.format(vcs_modified),
            file_data,
            flags=re.IGNORECASE
        )

        # Write the new content to the output file
        with open(output_file, 'w') as file:
            file.write(file_data)

        print(f"File processed and saved as {output_file}")

    except FileNotFoundError:
        print(f"The file {input_file} does not exist.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    replace_text_in_file(
        "resources/Varda_Scheme.xml",
        "resources/Everforest_Scheme.xml",
        "Everforest",
        "D3C6AA",
        "1E2326",
        "272E33",
        "2E383C",
        "374145",
        "414B50",
        "495156",
        "4F5B58",
        "7A8478",
        "A7C080",
        "E69875",
        "DBBC7F",
        "E67E80",
        "83C092",
        "7FBBB3",
    )

    replace_text_in_file(
        "resources/Varda_Scheme.xml",
        "resources/Nord_Scheme.xml",
        "Nord",
        "D8DEE9",
        "2E3440",
        "3B4252",
        "3B4252",
        "434C5E",
        "434C5E",
        "4C566A",
        "4C566A",
        "5E81AC",
        "81A1C1",
        "8FBCBB",
        "EBCB8B",
        "BF616A",
        "A3BE8C",
        "5E81AC",
    )

    replace_text_in_file(
        "resources/Varda_Scheme.xml",
        "resources/Rosepine_Scheme.xml",
        "Rosepine",
        "E0DEF4",
        "191724",
        "1F1D2E",
        "21202E",
        "26233A",
        "403D52",
        "524F67",
        "6E6A86",
        "C4A7E7",
        "9CCFD8",
        "EBBCBA",
        "F6C177",
        "EB6F92",
        "31748F",
        "31748F",
    )

    replace_text_in_file(
        "resources/Varda_Scheme.xml",
        "resources/Bloodrust_Scheme.xml",
        "Bloodrust",
        "AFB3BD",
        "1F2932",
        "222E38",
        "25323D",
        "293642",
        "2C3A47",
        "2f3E4C",
        "324351",
        "7C545F",
        "5E4D52",
        "72547C",
        "7C7C54",
        "7C545F",
        "547C71",
        "54737C",
    )

    replace_text_in_file(
        "resources/Varda_Scheme.xml",
        "resources/Desertpower_Scheme.xml",
        "Desert Power",
        "A1A09F",
        "11100F",
        "22201E",
        "22201E",
        "33302D",
        "33302D",
        "3C3834",
        "3C3834",
        "55504D",
        "9EA886",
        "AF8F6B",
        "9EA886",
        "B5745A",
        "385752",
        "8EBABB",
    )

    replace_text_in_file(
        "resources/Varda_Scheme.xml",
        "resources/Catppuccinlatte_Scheme.xml",
        "Catppuccin Latte",
        "4C4F69",
        "EFF1F5",
        "DCE0E8",
        "E6E9EF",
        "CCD0DA",
        "BCC0CC",
        "ACB0BE",
        "9CA0B0",
        "8839EF",
        "DD7878",
        "7287FD",
        "DF8E1D",
        "E64553",
        "179299",
        "209FB5",
    )

replace_text_in_file(
    "resources/Varda_Scheme.xml",
    "resources/Catppuccinfrappe_Scheme.xml",
    "Catppuccin Frappé",
    "C6D0F5",
    "303446",
    "232634",
    "292C3C",
    "414559",
    "51576D",
    "626880",
    "737994",
    "CA9EE6",
    "EEBEBE",
    "BABBf1",
    "E5C890",
    "EA999C",
    "81C8BE",
    "85C1DC",
)

replace_text_in_file(
    "resources/Varda_Scheme.xml",
    "resources/Catppuccinmacchiato_Scheme.xml",
    "Catppuccin Macchiato",
    "CAD3F5",
    "24273A",
    "181926",
    "1E2030",
    "363A4F",
    "494D64",
    "5B6078",
    "6E738D",
    "C6A0F6",
    "F0C6C6",
    "B7BDF8",
    "EED49F",
    "EE99A0",
    "8BD5CA",
    "7DC4E4",
)

replace_text_in_file(
    "resources/Varda_Scheme.xml",
    "resources/Catppuccinmocha_Scheme.xml",
    "Catppuccin Mocha",
    "CDD6F4",
    "1E1E2E",
    "11111B",
    "181825",
    "313244",
    "45475A",
    "585B70",
    "6C7086",
    "CBA6F7",
    "F2CDCD",
    "B4BEFE",
    "F9E2AF",
    "EBA0AC",
    "94E2D5",
    "74C7EC",
)