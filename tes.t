import './App.css'
import { CacheProvider, type EmotionCache } from '@emotion/react';
import { QueryClientProvider } from '@tanstack/react-query';
import { CssBaseline, GlobalStyles, ThemeProvider } from '@mui/material';
import { SnackbarProvider, type SnackbarProviderProps } from 'notistack';
import { StyledEngineProvider } from '@mui/material/styles';
import { BrowserRouter, Route, Routes } from 'react-router';

import createEmotionCache from './utilities/emotion-cache';
import getQueryClient from './config/react-query';
import { themes } from './styles/mui/themes';
import { UseModalProvider } from './hooks/useModal/Provider';
import { publicRoutes } from './config/routes';
import LayoutPublicRoute from './components/layout/public_routes';

const snackbarConfig: SnackbarProviderProps = {
  anchorOrigin: {
    vertical: "top",
    horizontal: "right"
  },
  autoHideDuration: 5000,
  style: {
    maxWidth: 300
  }
}
interface CustomAppProps {
  emotionCache?: EmotionCache;
}

const clientSideEmotionCache = createEmotionCache();

/* Global React Query client untuk Server state, klo Client State tetep pake Redux */
const queryClient = getQueryClient(); 

function App({ emotionCache = clientSideEmotionCache }: CustomAppProps) {
  return (
    <AllProvider emotionCache={emotionCache}>
      <CssBaseline />
      <BrowserRouter>
        <Routes>
          <Route>
            {publicRoutes.map((route) => ( 
              <Route 
                key={route.key} 
                path={route.path} 
                element={route.noLayout ? (
                    <route.component />
                  ) : (
                    <LayoutPublicRoute>
                      <route.component />
                    </LayoutPublicRoute>
                  )
                } />
            ))}
          </Route>
        </Routes>
      </BrowserRouter>
    </AllProvider>
  )
}

export function AllProvider({
  children,
  emotionCache,
}: {
  children: React.ReactNode;
  emotionCache: EmotionCache;
}) {
  return (
    <QueryClientProvider client={queryClient}>
      <CacheProvider value={emotionCache}>
          <SnackbarProvider
            anchorOrigin={snackbarConfig.anchorOrigin}
            autoHideDuration={snackbarConfig.autoHideDuration}
            style={snackbarConfig.style}
          >
            <ThemeProvider theme={themes}>
              <StyledEngineProvider enableCssLayer>
                <GlobalStyles styles="@layer theme, base, mui, components, utilities;" />
                <UseModalProvider>{children}</UseModalProvider>
              </StyledEngineProvider>
            </ThemeProvider>
          </SnackbarProvider>
      </CacheProvider>
    </QueryClientProvider>
  );
}

export default App
