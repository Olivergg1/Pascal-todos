unit GlobalsUnit;

interface

type TEnvironment = (Development, Production);

const Environment: TEnvironment = Development;
const DATABASE_FILENAME: string = 'todos.sqlite';

implementation

end.