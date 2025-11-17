import { DefaultRubyVM } from "@ruby/wasm-wasi/dist/browser";

let rubyVM = null;

async function initRuby() {
  const response = await fetch(
    "https://cdn.jsdelivr.net/npm/@ruby/3.4-wasm-wasi@2.7.2/dist/ruby+stdlib.wasm"
  );
  const buffer = await response.arrayBuffer();
  const module = await WebAssembly.compile(buffer);

  const { vm } = await DefaultRubyVM(module);
  rubyVM = vm;

  // Load the Pesca module
  const baseUrl = import.meta.env.BASE_URL || '/';
  const pescaCode = await fetch(`${baseUrl}lib/pesca.rb`).then(r => r.text());
  rubyVM.eval(pescaCode);

  console.log("Ruby VM initialized with Pesca module loaded");
  document.getElementById('output').textContent = "Ready! Ruby VM initialized with Pesca module loaded.\n";
}

function executeRuby() {
  const code = document.getElementById('editor').value;
  const outputElement = document.getElementById('output');

  console.log("Execute button clicked");
  console.log("Code:", code);
  console.log("rubyVM:", rubyVM);

  if (!rubyVM) {
    outputElement.textContent = "Error: Ruby VM not initialized yet. Please wait...";
    return;
  }

  try {
    // Simple test first
    console.log("Attempting to eval...");
    const testResult = rubyVM.eval("'Hello from Ruby!'");
    console.log("Test result:", testResult);

    // Execute the code with output capture
    const result = rubyVM.eval(`
      require 'stringio'
      $captured_output = StringIO.new
      old_stdout = $stdout
      $stdout = $captured_output

      begin
        result = eval(<<-'RUBY_CODE'
        Pesca.reset!
${code}
      Pesca.assign!
RUBY_CODE
        )
        $captured_output.string
      rescue => e
        "Error: " + e.class.to_s + ": " + e.message + "\\n" + e.backtrace.join("\\n")
      ensure
        $stdout = old_stdout
      end
    `);

    console.log("Result:", result);
    outputElement.textContent = result.toString();
  } catch (error) {
    outputElement.textContent = `Error: ${error.message}`;
    console.error("Error executing:", error);
  }
}

// Initialize on page load
initRuby().catch(error => {
  document.getElementById('output').textContent = `Failed to initialize Ruby VM: ${error.message}`;
  console.error(error);
});

// Add event listener for the execute button
document.getElementById('execute').addEventListener('click', executeRuby);

// Allow Ctrl+Enter or Cmd+Enter to execute
document.getElementById('editor').addEventListener('keydown', (e) => {
  if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
    e.preventDefault();
    executeRuby();
  }
});
