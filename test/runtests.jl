using RAKE
using Base.Test

# write your own tests here
@test 1 == 2


@testset "Test remove redundant whitespace"
begin
    @test remove_redundant_whitespace(" a") == "a"
    @test remove_redundant_whitespace(" a  b") == "a b"
    @test remove_redundant_whitespace("Bob  the builder") == "Bob the builder"
end
