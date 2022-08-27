#[macro_export]
macro_rules! input_file {
    ($N:literal) => {
        include_str!(concat!(
            env!("CARGO_MANIFEST_DIR"),
            "/../inputs/day",
            $N,
            ".txt"
        ))
    };
}
