test_that("nesting works", {
  expect_known_output(nest_tables(seabirddiet[1:3,], metrics = "freq_occ"),
                      file =  here::here("inst", "testdata", "nest_test.Rdata")
  )
})

test_that("popup works", {
    expect_known_output(make_popup(nest_tables(seabirddiet[1:3,], metrics = "freq_occ")),
                        file =  here::here("inst", "testdata", "popup_test.Rdata")
    )
})


