require "rack_session_mongo/version"
require 'rack/session/abstract/id'
require 'thread'
class Rack::Session::Mongo < Rack::Session::Abstract::ID
    DEFAULT_OPTIONS = Rack::Session::Abstract::ID::DEFAULT_OPTIONS.merge :drop => false
    def initialize(app, options={})
        super
        @coll = options[:collection]
        @pool={}
        @coll.find.each do |x|
            @pool.store x[:sid], x[:session]
        end
        @mutex = Mutex.new
    end
    def include?(sid)
        @pool.has_key? sid
    end
    def store(sid,session)
        @pool.store sid, session
        @coll.update_one({:sid => sid},{:sid => sid, :session => session},{:upsert => true})
    end
    def get(sid)
        @pool[sid]
    end
    def delete(sid)
        @pool.delete(sid)
        @coll.delete(:sid => sid)
    end
    def generate_sid
        loop do
            sid = super
            break sid unless include?(sid)
        end
    end
    def find_session(req, sid)
        with_lock(req) do
            unless sid and session=get(sid) 
                sid, session = generate_sid, {}
                store sid, session
            end
            [sid, session]
        end
    end
    def write_session(req, session_id, new_session, options)
        with_lock(req) do
            store session_id, new_session
            session_id
        end
    end
    def delete_session(req, session_id, options)
        with_lock(req) do
            delete(session_id)
            generate_sid unless options[:drop]
        end
    end
    def with_lock(req)
        @mutex.lock
        yield
        ensure
        @mutex.unlock if @mutex.locked?
    end
    alias :get_session :find_session
    alias :set_session :write_session
end
