namespace Motqin.Dtos.Api
{
    public class ApiResponse<T>
    {
        public bool Success { get; set; }
        public T? Data { get; set; }
        public ErrorResponse? Error { get; set; }

        public static ApiResponse<T> Ok(T data) => new ApiResponse<T> { Success = true, Data = data };
        public static ApiResponse<T> Fail(string code, string message) => new ApiResponse<T> { Success = false, Error = new ErrorResponse { Code = code, Message = message } };
    }
}
