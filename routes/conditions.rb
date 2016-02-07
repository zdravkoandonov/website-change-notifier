set(:authenticate) do |enabled|
  condition do
    redirect to('/login') if enabled and not authenticated?
  end
end
