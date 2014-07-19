module RestClientFatalRequestError
  EXCEPTION_CLASSES = [
    RestClient::Exception,
    Errno::ECONNREFUSED,
    Errno::ECONNRESET,
    Errno::EADDRNOTAVAIL,
    Errno::EHOSTDOWN,
    Errno::EHOSTUNREACH,
    Errno::ENETUNREACH,
    Errno::ECONNABORTED,
    Errno::ETIMEDOUT,
    Errno::ENONET,
    Timeout::Error,
    SocketError
  ]

  def self.===(e)
    EXCEPTION_CLASSES.any? {|klass| e.is_a?(klass) }
  end
end
