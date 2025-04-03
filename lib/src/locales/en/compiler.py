import os

def compile_dart_files(output_filename='compiled_dart_files.txt'):
    # Get the directory where the script is located.
    base_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Open the output file for writing.
    with open(os.path.join(base_dir, output_filename), 'w', encoding='utf-8') as outfile:
        # Walk through the directory and its subdirectories.
        for root, _, files in os.walk(base_dir):
            for file in files:
                if file.endswith('.dart'):
                    file_path = os.path.join(root, file)
                    try:
                        with open(file_path, 'r', encoding='utf-8') as dart_file:
                            content = dart_file.read()
                    except Exception as e:
                        print(f"Error reading {file_path}: {e}")
                        continue

                    # Write the file name and content to the output file.
                    outfile.write(f"{file}\n")
                    outfile.write(content)
                    outfile.write("\n\n")  # Add some spacing between files

if __name__ == '__main__':
    compile_dart_files()
