use utils::VirtualBox;

mod compile;
mod parse;
mod utils;

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let Some(path) = args.get(1) else {
        eprintln!(
            "Usage: {} <path>",
            args.get(0).map(String::as_str).unwrap_or_else(|| "bfjit")
        );
        std::process::exit(1);
    };

    let bf = match std::fs::read(path) {
        Ok(bf) => bf,
        Err(e) => {
            eprintln!("Error reading file: {e}");
            std::process::exit(1);
        }
    };

    let il = match parse::parse_bf(&bf) {
        Ok(il) => il,
        Err(e) => {
            eprintln!("Error parsing file: {e}");
            std::process::exit(1);
        }
    };

    let asm = match compile::assemble_x64(&il) {
        Ok(asm) => asm,
        Err(e) => {
            eprintln!("Error assembling file: {e}");
            std::process::exit(1);
        }
    };

    let program = unsafe {
        let mut program = VirtualBox::new_with_size(asm.len());
        program.copy_from(asm.as_ptr());

        if let Err(e) = program.make_executable() {
            eprintln!("Error granting executable permissions for program: {e}");
            std::process::exit(1);
        }

        program
    };

    unsafe {
        let program: extern "C" fn() -> i32 = std::mem::transmute(program.as_mut_ptr());
        let ret = program();
        std::process::exit(ret);
    }
}
