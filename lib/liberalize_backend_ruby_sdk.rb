require "base64"
require 'uri'
require 'net/http'
require 'json'

class LiberalizeBackendRubySdk

    def initialize(privateKey, environment="production")

        case environment
        when "production"
            @paymentApi = "https://payment.api.liberalize.io/payments"
            @customerApi = "https://customer.api.liberalize.io"
        when "staging"
            @paymentApi = "https://payment.api.staging.liberalize.io/payments"
            @customerApi = "https://customer.api.staging.liberalize.io"
        when "dev"
            @paymentApi = "https://payment.api.dev.liberalize.io/payments"
            @customerApi = "https://customer.api.dev.liberalize.io"
        when "local"
            @paymentApi = "https://payment.api.dev.liberalize.io/payments"
            @customerApi = "https://customer.api.dev.liberalize.io"
        end

        @privateKey = Base64.strict_encode64("#{privateKey}:")

    end

    def createPayment(requestBody, libService="elements")
        begin
            validatedRequest = {}
            requestBody.each do |key, value|
                case "#{key}"
                when "amount"
                    target_amount = value.to_i
                    validatedRequest[:amount] = target_amount
                when "source"
                    if value.is_a?(String)
                        validatedRequest[:source] = value
                    else
                        validatedRequest[:source] = "lib:customer:paymentMethods/#{value[:paymentMethodId]}"
                    end
                else
                    validatedRequest[key] = value
                end
            end

            uri = URI.parse(@paymentApi)
            body = validatedRequest.to_json
            header = {
                "Content-Type": "application/json",
                "x-lib-pos-type": "#{libService}",
                "Authorization": "Basic #{@privateKey}",
            }

            http = Net::HTTP.new(uri.host, uri.port)
            # http.set_debug_output($stdout)
            http.use_ssl = true
            request = Net::HTTP::Post.new(uri.request_uri, header)
            request.body = body

            response = http.request(request)

            if response.code.to_i >= 200 && response.code.to_i < 300
                return response.body
            else
                return response
            end
        rescue Exception => exception

            return exception
        end
    end

    def authorizePayment(requestBody, libService="elements")
        begin
            validatedRequest = {}
            paymentId = ""
            requestBody.each do |key, value|
                case "#{key}"
                when "source"
                    if value.is_a?(String)
                        validatedRequest[:source] = value
                    else
                        validatedRequest[:source] = "lib:customer:paymentMethods/#{value[:paymentMethodId]}"
                    end
                when "paymentId"
                    paymentId = value
                else
                    validatedRequest[key] = value
                end
            end

            uri = URI.parse(@paymentApi + "/#{paymentId}/authorizations")
            body = validatedRequest.to_json
            header = {
                "Content-Type": "application/json",
                "x-lib-pos-type": "#{libService}",
                "Authorization": "Basic #{@privateKey}",
            }

            http = Net::HTTP.new(uri.host, uri.port)
            # http.set_debug_output($stdout)
            http.use_ssl = true
            request = Net::HTTP::Post.new(uri.request_uri, header)
            request.body = body

            response = http.request(request)

            if response.code.to_i >= 200 && response.code.to_i < 300
                return response.body
            else
                return response
            end
        rescue Exception => exception

            return exception
        end
    end

    def capturePayment(requestBody, libService="elements")
        begin
            validatedRequest = {}
            paymentId = ""
            requestBody.each do |key, value|
                case "#{key}"
                when "amount"
                    target_amount = value.to_i
                    validatedRequest[:amount] = target_amount
                when "paymentId"
                    paymentId = value
                else
                    validatedRequest[key] = value
                end
            end

            uri = URI.parse(@paymentApi + "/#{paymentId}/captures")
            body = validatedRequest.to_json
            header = {
                "Content-Type": "application/json",
                "x-lib-pos-type": "#{libService}",
                "Authorization": "Basic #{@privateKey}",
            }

            http = Net::HTTP.new(uri.host, uri.port)
            # http.set_debug_output($stdout)
            http.use_ssl = true
            request = Net::HTTP::Post.new(uri.request_uri, header)
            request.body = body

            response = http.request(request)

            if response.code.to_i >= 200 && response.code.to_i < 300
                return response.body
            else
                return response
            end
        rescue Exception => exception

            return exception
        end
    end

    def refundPayment(requestBody, libService="elements")
        begin
            validatedRequest = {}
            paymentId = ""
            requestBody.each do |key, value|
                case "#{key}"
                when "amount"
                    target_amount = value.to_i
                    validatedRequest[:amount] = target_amount
                when "paymentId"
                    paymentId = value
                else
                    validatedRequest[key] = value
                end
            end

            uri = URI.parse(@paymentApi + "/#{paymentId}/refunds")
            body = validatedRequest.to_json
            header = {
                "Content-Type": "application/json",
                "x-lib-pos-type": "#{libService}",
                "Authorization": "Basic #{@privateKey}",
            }

            http = Net::HTTP.new(uri.host, uri.port)
            http.set_debug_output($stdout)
            http.use_ssl = true
            request = Net::HTTP::Post.new(uri.request_uri, header)
            request.body = body

            response = http.request(request)

            if response.code.to_i >= 200 && response.code.to_i < 300
                return response.body
            else
                return response
            end
        rescue Exception => exception

            return exception
        end
    end

    def voidPayment(requestBody, libService="elements")
        begin
            validatedRequest = {}
            paymentId = ""
            requestBody.each do |key, value|
                case "#{key}"
                when "paymentId"
                    paymentId = value
                else
                    validatedRequest[key] = value
                end
            end

            uri = URI.parse(@paymentApi + "/#{paymentId}/voids")
            body = validatedRequest.to_json
            header = {
                "Content-Type": "application/json",
                "x-lib-pos-type": "#{libService}",
                "Authorization": "Basic #{@privateKey}",
            }

            http = Net::HTTP.new(uri.host, uri.port)
            # http.set_debug_output($stdout)
            http.use_ssl = true
            request = Net::HTTP::Post.new(uri.request_uri, header)
            request.body = body

            response = http.request(request)

            if response.code.to_i >= 200 && response.code.to_i < 300
                return response.body
            else
                return response
            end
        rescue Exception => exception

            return exception
        end
    end

    def getPayment(paymentId, libService="elements")
        begin
            uri = URI.parse(@paymentApi + "/#{paymentId}")
            header = {
                "Content-Type": "application/json",
                "x-lib-pos-type": "#{libService}",
                "Authorization": "Basic #{@privateKey}",
            }

            http = Net::HTTP.new(uri.host, uri.port)
            # http.set_debug_output($stdout)
            http.use_ssl = true
            request = Net::HTTP::Get.new(uri.request_uri, header)

            response = http.request(request)

            if response.code.to_i >= 200 && response.code.to_i < 300
                return response.body
            else
                return response
            end
        rescue Exception => exception

            return exception
        end
    end

end